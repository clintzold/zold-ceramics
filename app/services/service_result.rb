# app/services/service_result.rb
ServiceResult = Struct.new(:success?, :payload, :errors, keyword_init: true) do
  def failure?
    !success?
  end
end
