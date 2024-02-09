require 'rails_helper'

RSpec.describe "DeviceReadings", type: :request do
  let(:reading1) { DeviceReading.new(timestamp: '2024-01-01T00:00:00', count: 1) }
  let(:reading2) { DeviceReading.new(timestamp: '2024-01-01T00:01:00', count: 2) }
  let(:reading3) { DeviceReading.new(timestamp: '2024-01-01T00:02:00', count: 3) }
  let(:device_log_1) { DeviceLog.new(id: 'device-id-1', readings: [reading1, reading2, reading3]) }
  let(:repo) { DeviceLogRepository.new }
 
  before(:each) { repo.clear}

  describe "GET /store" do
    context 'when the device log does not exist for the id' do
      it 'creates a new device log and adds readings' do
        post "/device-readings", params: { id: 'device-id-2', readings: [{ timestamp: '2024-01-01T00:00:00', count: 1 }] }

        expect(response).to have_http_status(:ok)
        # expect(response.body).to eq({ device_id: 'device-id-2', cumulative_count: 1, latest_timestamp: '2024-01-01T00:00:00' }.to_json)
      end
    end

    context 'when the device log exists for the id' do
      before(:each) { repo.save('device-id-1', device_log_1)}

      it 'adds readings to the existing device log' do
        post "/device-readings", params: { id: 'device-id-1', readings: [{ timestamp: '2024-01-01T00:03:00', count: 1 }] }

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ device_id: 'device-id-1', cumulative_count: 7, latest_timestamp: '2024-01-01T00:03:00' }.to_json)
      end

      context 'when a reading is invalid' do
        it 'returns a 422' do
          post "/device-readings", params: { id: 'device-id-1', readings: [{ timestamp: '2024-01-01T00:03:00' }] }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

    end

  end

  describe "GET /latest_timestamp" do
    context "when the device log exists for the id" do
      before(:each) { repo.save('device-id-1', device_log_1)}

      it "returns the latest timestamp" do
        get "/device-readings/device-id-1/latest-timestamp"
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ latest_timestamp: '2024-01-01T00:02:00' }.to_json)
      end
    end

    context "when the device log does not exist for the id" do
      it "returns a 404" do
        get "/device-readings/device-id-2/cumulative-count"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /cumulative-count" do
    context "when the device log exists for the id" do
      before(:each) { repo.save('device-id-1', device_log_1)}

      it "returns the cumulative count" do
        get "/device-readings/device-id-1/cumulative-count"
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ cumulative_count: 6 }.to_json)
      end
    end

    context "when the device log does not exist for the id" do
      it "returns a 404" do
        get "/device-readings/device-id-2/cumulative-count"
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
