class DeviceLogRepository

    def find(device_id)
        device_log = Rails.cache.read(device_id)

        if device_log.nil?
            raise DeviceExceptions::DeviceLogNotFound.new("Log for device #{device_id} not found")
        end

        device_log
    end

    def find_or_new(device_id)
        Rails.cache.read(device_id) || DeviceLog.new(id: device_id)
    end

    def save(device_id, device_log)
        Rails.cache.write(device_id, device_log)
    end

    def clear
        Rails.cache.clear
    end

end
