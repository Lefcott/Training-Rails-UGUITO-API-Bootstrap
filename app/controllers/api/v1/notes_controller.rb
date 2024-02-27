module Api
  module V1
    class NotesController < ApplicationController
      before_action :authenticate_user!

      def index
        type = params[:type]
        page_size = params[:page_size]
        max_page_size = 100

        if page_size.to_i > max_page_size
          return render json: { error: "page_size is too long, max allowed is #{max_page_size}" }, status: :bad_request
        end

        if type && !Note.types.keys.include?(type)
          return render json: { error: "invalid type #{type}" }, status: :unprocessable_entity
        end
        render json: notes_filtered, status: :ok, each_serializer: IndexNoteSerializer
      end

      def show
        render json: show_note, status: :ok, serializer: ShowNoteSerializer
      end

      def create
        note = current_user.notes.new(create_note_params)

        if note.save
          render json: { message: 'Nota creada con éxito.' }, status: :created
        else
          render json: { errors: note.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def notes
        current_user.notes
      end

      def notes_filtered
        order, page, page_size = params.values_at(:order, :page, :page_size)
        notes.where(filtering_params).order(created_at: order || :desc).page(page).per(page_size)
      end

      def filtering_params
        params.permit %i[type]
      end

      def show_note
        notes.find(params.require(:id))
      end

      def create_note_params
        params.permit(:title, :type, :content)
      end
    end
  end
end
