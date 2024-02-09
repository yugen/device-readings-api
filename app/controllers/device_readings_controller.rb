class DeviceReadingsController < ApplicationController
    before_action :find_device_log, only: [:latest_timestamp, :cumulative, :show]

    def initialize
        super
        @device_log_repo = DeviceLogRepository.new
    end

    def store
        deviceReadings = store_params[:readings].map{ |hash| DeviceReading.from_params(hash) }
        
        # We want to init a new log if it doesn't exist
        @device_log = @device_log_repo.find_or_new(store_params[:id]);

        begin
            @device_log.add_readings(deviceReadings);
        rescue ActiveModel::ValidationError => e
            return render json: { errors: e.model.errors }, status: :unprocessable_entity
        end

        @device_log_repo.save(store_params[:id], @device_log);

        # No return value in defined specifications, so I'm going with this for now. 
        render json: {
            device_id: store_params[:id], 
            cumulative_count: @device_log.cumulative, 
            latest_timestamp: @device_log.latest_timestamp
        }
    end

    def latest_timestamp        
        render json: { 
            latest_timestamp: @device_log.latest_timestamp 
        }
    end

    def cumulative
        render json: { 
            cumulative_count: @device_log.cumulative 
        }
    end

    def show
        render json: @device_log
    end

    private 
    
    def store_params
        params.permit(:id, readings: [:timestamp, :count]);
    end

    def find_device_log
        begin
            @device_log = @device_log_repo.find(params[:id]);
        rescue DeviceExceptions::DeviceLogNotFound => e
            return render json: { errors: "Log for device #{params[:id]} not found" }, status: :not_found
        end
    end
end

