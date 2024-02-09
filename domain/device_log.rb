class DeviceLog
    include ActiveModel::Serializers::JSON

    attr_accessor :id, :readings, :cumulative, :latest_timestamp

    def initialize(id:, readings: [])
        @id = id
        @readings = []
        @cumulative = 0
        @latest_timestamp = nil
        add_readings(readings)
    end

    def attributes
        {
            'readings' => [], 
            'cumulative' => 0, 
            'latest_timestamp' => nil
        }
    end

    def add_reading(reading)
        return if reading.nil?
        return if @readings.any? { |r| r.timestamp == reading.timestamp }

        unless reading.valid?
            raise ActiveModel::ValidationError.new(reading)
        end

        @readings << reading
        @cumulative += reading.count || 0
        @latest_timestamp = reading.timestamp if @latest_timestamp.nil? || reading.timestamp > @latest_timestamp
    end

    def add_readings(new_readings)
        return if (new_readings.nil? || new_readings.empty?)
        
        new_readings.each do |reading|
            add_reading(reading)
        end
    end

    def ==(other)
        return false if other.nil?
        return false if other.class != self.class
        
        other.id == @id
    end
end