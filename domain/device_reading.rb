class DeviceReading
    include ActiveModel::Serializers::JSON
    include ActiveModel::Validations

    attr_accessor :timestamp, :count

    validates :timestamp, presence: true, format: { with: /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\+|\-)\d{2}:\d{2}/ }
    validates :count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    
    def initialize(timestamp:, count:)
        @timestamp = timestamp
        @count = count
    end

    def attributes
        {
            'timestamp' => nil,
            'count' => nil
        }
    end

    def ==(other)
        @timestamp == other.timestamp && @count == other.count
    end

    def self.from_params(params)
        count = Integer(params[:count]) unless params[:count].nil?
        DeviceReading.new(timestamp: params[:timestamp], count: count)
    end
end