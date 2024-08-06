require 'net/http'
require 'json'

module BeamVerification
  BEAM_API_URL = "https://beam-api-url"

  def self.get_balance(beam_address)
    uri = URI("#{BEAM_API_URL}/balance/#{beam_address}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)['balance']
  end
end
