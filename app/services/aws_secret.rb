# frozen-string-literal: true

require 'aws-sdk-secretsmanager'
require 'base64'

# The `get` method is basically cut and paste from the AWS example.
# Probably good to keep all the rescues in this method, they are
# really helpful if something goes wrong.
class AwsSecret
  def get(secret_name, region_name)
    client = Aws::SecretsManager::Client.new(region: region_name)

    # In this sample we only handle the specific exceptions for the 'GetSecretValue' API.
    # See https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
    # We rethrow the exception by default.
    begin
      get_secret_value_response = client.get_secret_value(secret_id: secret_name)
    rescue Aws::SecretsManager::Errors::DecryptionFailure => _e
      # Secrets Manager can't decrypt the protected secret text using the provided KMS key.
      # Deal with the exception here, and/or rethrow at your discretion.
      raise
    rescue Aws::SecretsManager::Errors::InternalServiceError => _e
      # An error occurred on the server side.
      # Deal with the exception here, and/or rethrow at your discretion.
      raise
    rescue Aws::SecretsManager::Errors::InvalidParameterException => _e
      # You provided an invalid value for a parameter.
      # Deal with the exception here, and/or rethrow at your discretion.
      raise
    rescue Aws::SecretsManager::Errors::InvalidRequestException => _e
      # You provided a parameter value that is not valid for the current state of the resource.
      # Deal with the exception here, and/or rethrow at your discretion.
      raise
    rescue Aws::SecretsManager::Errors::ResourceNotFoundException => _e
      # We can't find the resource that you asked for.
      # Deal with the exception here, and/or rethrow at your discretion.
      raise
    else
      # This block is ran if there were no exceptions.

      # Decrypts secret using the associated KMS CMK.
      # Depending on whether the secret is a string or binary, one of these fields will be populated.
      if get_secret_value_response.secret_string
        secret = get_secret_value_response.secret_string
      else
        _decoded_binary_secret = Base64.decode64(get_secret_value_response.secret_binary)
      end

      JSON.parse(secret)
    end
  end
end
