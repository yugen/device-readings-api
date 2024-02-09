require 'rails_helper'

RSpec.describe "DeviceReading", type: :model do

    describe "initialize" do
        it "should initialize with a timestamp" do
            log = DeviceReading.new(timestamp: '2023-01-01T00:00:00', count: 1)
            expect(log.timestamp).to eq('2023-01-01T00:00:00')
        end

        it "should initialize with a count" do
            log = DeviceReading.new(timestamp: '2023-01-01T00:00:00', count: 1)
            expect(log.count).to eq(1)
        end
    end

    describe "validations" do
        describe "validations" do
            subject { DeviceReading.new(timestamp: nil, count: nil) }
            it { should validate_presence_of(:count) }
            it { should validate_numericality_of(:count).only_integer.is_greater_than_or_equal_to(0) }
            it { should validate_presence_of(:timestamp) }
            it 'should validate the format of the timestamp' do
                expect(subject).to allow_value('2023-01-01T00:00:00').for(:timestamp)
                expect(subject).to_not allow_value('2023-01-01').for(:timestamp)
            end
        end
    end

    describe "serialization" do
        let(:entry) { DeviceReading.new(timestamp: '2023-01-01T00:00:00', count: 1) }

        it "should return a serializable hash" do
            expect(entry.serializable_hash).to eq({ 'timestamp' => '2023-01-01T00:00:00', 'count' => 1 })
        end

        it "should serialize to json" do
            expect(entry.to_json).to eq("{\"timestamp\":\"2023-01-01T00:00:00\",\"count\":1}")
        end
    end

    describe '==' do
        context 'when timestamps and counts are the same' do
            it 'should be equal' do
                log1 = DeviceReading.new(timestamp: '2023-01-01T00:00:00', count: 1)
                log2 = DeviceReading.new(timestamp: '2023-01-01T00:00:00', count: 1)
                expect(log1).to eq(log2)
            end
        end
    end
end