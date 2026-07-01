require "net/http"
require "uri"
require "json"

module Api
  module V1
    class PostsController < ApplicationController
      JSONPLACEHOLDER_URL = "https://jsonplaceholder.typicode.com/posts".freeze
      JSONPLACEHOLDER_HOST = "jsonplaceholder.typicode.com".freeze
      JSONPLACEHOLDER_PORT = 443

      # GET /v1/posts
      def index
        uri = URI(JSONPLACEHOLDER_URL)
        response = Net::HTTP.get_response(uri)

        if response.is_a?(Net::HTTPSuccess)
          posts = JSON.parse(response.body)
          render json: posts, status: :ok
        else
          render json: { error: "Error al obtener publicaciones de JSONPlaceholder" }, status: response.code.to_i
        end
      rescue => e
        render json: { error: "Error de red: #{e.message}" }, status: :service_unavailable
      end

      # GET /v1/posts/:id
      def show
        id = params[:id].to_i

        if id > 100
          # Mock para posts recién creados en el frontend
          render json: { id: id, title: "Publicación simulada #{id}", body: "Contenido de la publicación simulada #{id}", userId: 1 }, status: :ok
          return
        end

        response = Net::HTTP.start(JSONPLACEHOLDER_HOST, JSONPLACEHOLDER_PORT, use_ssl: true) do |http|
          http.get("/posts/#{id}")
        end

        if response.is_a?(Net::HTTPSuccess)
          post = JSON.parse(response.body)
          render json: post, status: :ok
        else
          render json: { error: "Publicación no encontrada" }, status: response.code.to_i
        end
      rescue => e
        render json: { error: "Error de red: #{e.message}" }, status: :service_unavailable
      end

      # POST /v1/posts
      def create
        header = { "Content-Type" => "application/json; charset=UTF-8" }

        # El servicio espera title, body y userId
        post_data = {
          title: params[:title],
          body: params[:body] || params[:content],
          userId: current_user.id
        }

        response = Net::HTTP.start(JSONPLACEHOLDER_HOST, JSONPLACEHOLDER_PORT, use_ssl: true) do |http|
          request = Net::HTTP::Post.new("/posts", header)
          request.body = post_data.to_json
          http.request(request)
        end

        if response.code.to_i == 201
          created_post = JSON.parse(response.body)
          render json: created_post, status: :created
        else
          render json: { error: "Error al crear la publicación en el servicio externo" }, status: response.code.to_i
        end
      rescue => e
        render json: { error: "Error de red: #{e.message}" }, status: :service_unavailable
      end

      # PUT/PATCH /v1/posts/:id
      def update
        id = params[:id].to_i

        post_data = {
          id: id,
          title: params[:title],
          body: params[:body] || params[:content],
          userId: current_user.id
        }

        if id > 100
          # Retornar éxito simulado para IDs creados dinámicamente
          render json: post_data, status: :ok
          return
        end

        header = { "Content-Type" => "application/json; charset=UTF-8" }

        response = Net::HTTP.start(JSONPLACEHOLDER_HOST, JSONPLACEHOLDER_PORT, use_ssl: true) do |http|
          request = Net::HTTP::Put.new("/posts/#{id}", header)
          request.body = post_data.to_json
          http.request(request)
        end

        if response.is_a?(Net::HTTPSuccess)
          updated_post = JSON.parse(response.body)
          render json: updated_post, status: :ok
        else
          render json: { error: "Error al actualizar la publicación" }, status: response.code.to_i
        end
      rescue => e
        render json: { error: "Error de red: #{e.message}" }, status: :service_unavailable
      end

      # DELETE /v1/posts/:id
      def destroy
        id = params[:id].to_i

        if id > 100
          # Retornar éxito simulado para IDs creados dinámicamente
          render json: { message: "Publicación eliminada exitosamente (simulado)" }, status: :ok
          return
        end

        response = Net::HTTP.start(JSONPLACEHOLDER_HOST, JSONPLACEHOLDER_PORT, use_ssl: true) do |http|
          request = Net::HTTP::Delete.new("/posts/#{id}")
          http.request(request)
        end

        if response.is_a?(Net::HTTPSuccess)
          render json: { message: "Publicación eliminada exitosamente" }, status: :ok
        else
          render json: { error: "Error al eliminar la publicación" }, status: response.code.to_i
        end
      rescue => e
        render json: { error: "Error de red: #{e.message}" }, status: :service_unavailable
      end
    end
  end
end
