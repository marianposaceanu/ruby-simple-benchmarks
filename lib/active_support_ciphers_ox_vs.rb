require 'openssl'
require 'benchmark'
require 'active_support'
require 'ox'

module BfThinLayer
  class CryptStore
    class << self
      SECRET_KEY = "x" * 64
      SALT       = "\r\xFD\xF8L\xDD3\xB4V\xC8,\ei;`\xBB6\n\x82'\x024\x1D\xD9\x05\xFD\xC3\x8F\x89"
      KEY        = ActiveSupport::KeyGenerator.new(SECRET_KEY).generate_key(SALT).freeze

      attr_accessor :cipher_algorithm
      attr_accessor :serializer

      def load(value)
        cipher.decrypt
        cipher.key = KEY
        cipher.iv  = SALT

        decrypted = cipher.update(value) + cipher.final

        serializer.load(decrypted)
      end

      def dump(value)
        to_encrypt = serializer.dump(value)

        cipher.encrypt
        cipher.key = KEY
        cipher.iv  = SALT

        cipher.update(to_encrypt) + cipher.final
      end

      private

      def cipher
        @cipher_algorithm ||= 'aes-256-cbc'
        @cipher_digest ||= OpenSSL::Cipher.new(@cipher_algorithm)
      end

      def serializer
        @serializer ||= Marshal
      end
    end
  end
end

raw_data = {
  session_id: '99e14c789176e416d777c5170f7e0c0f',
  token: '43AA14F7-9B2A-4B17-963A-7D18825D1193',
  lang: 'de',
  other_info: [1,2,3,4]
}


n = 10000000

Benchmark.bmbm(10) do |x|
  x.report('AES CBC 256 with Marshal') do
    BfThinLayer::CryptStore.dump(raw_data)
  end

  x.report('AES ECB 256 with Ox') do
    BfThinLayer::CryptStore.serializer = Ox
    BfThinLayer::CryptStore.dump(raw_data)
  end
end
