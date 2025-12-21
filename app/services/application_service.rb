# app/services/application_service.rb
class ApplicationService
  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs, &block).call
  end

  private

  def success(payload = nil)
    ServiceResult.new(success?: true, payload: payload, errors: [])
  end

  def failure(errors)
    ServiceResult.new(success?: false, payload: nil, errors: Array(errors))
  end
end
