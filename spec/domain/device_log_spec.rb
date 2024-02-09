require 'rails_helper'

RSpec.describe "DeviceLog", type: :model do
    let(:timestamp1) { '2023-01-01T00:00:00+00:00' }
    let(:timestamp2) { '2023-01-01T00:01:00+00:00' }
    let(:timestamp3) { '2023-01-01T00:02:00+00:00' }
    let(:reading1) { DeviceReading.new(timestamp: timestamp1, count: 1) }
    let(:reading2) { DeviceReading.new(timestamp: timestamp2, count: 3) }
    let(:reading3) { DeviceReading.new(timestamp: timestamp3, count: 5) }

    describe "initialize" do
        let(:readings) { [reading1, reading2] }
        it "should initialize with empty readings" do
            log = DeviceLog.new(id: 'device_id')
            expect(log.readings).to eq([])
        end

        context "when readings are present" do
            it "should initialize with readings" do
                log = DeviceLog.new(id: 'device-id', readings: readings)
                expect(log.readings).to eq(readings)
            end

            it "should initialize with cumulative count" do
                log = DeviceLog.new(id: 'device-id', readings: readings)
                expect(log.cumulative).to eq(4)
            end

            it "should initialize with latest timestamp" do
                log = DeviceLog.new(id: 'device-id', readings: readings)
                expect(log.latest_timestamp).to eq(timestamp2)
            end
        end
    end

    describe "add_reading" do
        let(:log) { DeviceLog.new(id: 'some-id') }
        context "when readings are nil" do
            it "should not add readings" do
                log.add_readings(nil)
                expect(log.readings).to eq([])
            end
        end

        context "when readings are empty" do
            it "should not add readings" do
                log.add_readings([])
                expect(log.readings).to eq([])
            end
        end

        context "when readings are present" do
            it "should add readings" do
                log.add_reading(reading1)
                expect(log.readings.length).to eq(1)

                log.add_reading(reading2)
                expect(log.readings.length).to eq(2)
            end

            it "should add new counts to cumulative count" do
                log.add_reading(reading1)
                log.add_reading(reading2)
                expect(log.cumulative).to eq(4)

                log.add_reading(reading3)
                expect(log.cumulative).to eq(9)
            end

            it "should set latest timestamp regardless of reading order" do
                log.add_reading(reading2)
                log.add_reading(reading1)
                expect(log.latest_timestamp).to eq(timestamp2)
            end

            context 'when the a reading with the same timestamp is added again' do
                let(:duplicate_reading_hash) { DeviceReading.new(timestamp: timestamp1, count: 100) }
                let(:log) { DeviceLog.new(id: 'some-id', readings: [reading1, reading2]) }

                it "should not add duplicate readings" do
                    log.add_reading(duplicate_reading_hash)
                    expect(log.readings).to eq([reading1, reading2])
                end

                it "should not update cumulative count" do
                    log.add_reading(duplicate_reading_hash)
                    expect(log.cumulative).to eq(4)
                end

                it "should not update timestamp" do
                    log.add_reading(duplicate_reading_hash)
                    expect(log.cumulative).to eq(4)
                end

                it "raises a ActiveModel::ValidationError if the reading is invalid" do
                    expect{ log.add_reading(DeviceReading.new(timestamp: nil, count: nil)) }.to raise_error(ActiveModel::ValidationError)
                end
            end
        end
    end

    describe "add_readings" do
        it "should call add_reading for each reading" do
            log = DeviceLog.new(id: 'some-id')
            expect(log).to receive(:add_reading).with(reading1)
            expect(log).to receive(:add_reading).with(reading2)
            expect(log).to receive(:add_reading).with(reading3)

            log.add_readings([reading1, reading2, reading3])
        end
    end
end
