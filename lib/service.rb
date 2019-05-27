# frozen_string_literal: true

class Service
  Result = Struct.new(:success?, :result, :error, keyword_init: true)

  def self.call(*args)
    new(*args).call
  end

  def result(*args)
    Result.new(*args)
  end
end
