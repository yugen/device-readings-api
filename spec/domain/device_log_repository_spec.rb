require 'rails_helper'

RSpec.describe "DeviceLogRepository" do
    let(:device_log_repo) { DeviceLogRepository.new }
    let(:device_id) { 'device_id' }
    let(:device_log) { DeviceLog.new(id: device_id) }

    describe "find" do
        context "when the log exists" do
            it "should return the log" do
                Rails.cache.write(device_id, device_log)
                expect(device_log_repo.find(device_id)).to eq(device_log)
            end
        end

        context "when the log does not exist" do
            it "should raise an error" do
                expect{ device_log_repo.find('some-other-id') }.to raise_error(DeviceExceptions::DeviceLogNotFound)
            end
        end
    end

    describe "find_or_new" do
        context "when the log exists" do
            it "should return the log" do
                Rails.cache.write(device_id, device_log)
                expect(device_log_repo.find_or_new(device_id)).to eq(device_log)
            end
        end

        context "when the log does not exist" do
            it "should return a new log" do
                expect(device_log_repo.find_or_new(device_id)).to eq(DeviceLog.new(id: device_id))
            end
        end
    end

    describe "save" do
        it "should save the log" do
            device_log_repo.save(device_id, device_log)
            expect(Rails.cache.read(device_id)).to eq(device_log)
        end
    end

    describe "clear" do
        it "should clear the cache" do
            Rails.cache.write(device_id, device_log)
            device_log_repo.clear
            expect(Rails.cache.read(device_id)).to be_nil
        end
    end
end
