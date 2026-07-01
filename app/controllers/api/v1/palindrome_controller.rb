module Api
  module V1
    class PalindromeController < ApplicationController
      # POST /v1/palindrome/check
      def check
        words = params[:words]
        
        unless words.is_a?(Array) && words.length > 2
          return render json: { error: 'Debe proporcionar más de dos palabras (mínimo 3 palabras)' }, status: :unprocessable_entity
        end
        
        results = words.map do |word|
          {
            word: word,
            palindrome: palindrome?(word)
          }
        end
        
        render json: { results: results }, status: :ok
      end
      
      private
      
      def palindrome?(str)
        return false if str.blank?
        # Limpiar acentos, mayúsculas, espacios y caracteres especiales
        cleaned = str.to_s.downcase.gsub(/[^a-z0-9ñáéíóúü]/, '')
        normalized = cleaned
                       .tr('áéíóúü', 'aeiouu')
        normalized == normalized.reverse
      end
    end
  end
end
