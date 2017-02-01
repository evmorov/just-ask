module Requests
  module ApiHelpers
    def response_body
      JSON.parse(response.body)
    end
  end
end
