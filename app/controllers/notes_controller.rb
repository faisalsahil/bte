class NotesController < ApplicationController
  load_and_authorize_resource
  
  before_action :set_branch, only: [:index, :new, :create, :edit, :update, :destroy]
  
  def index
    if params[:branch_id].present?
      @notes = @branch.notes.order('created_at DESC')
    else
      @notes = Note.all.group_by { |d| d[:branch_id] }
    end
  end
  
  def new
    @note = @branch.notes.build
  end

  def edit
    @note = Note.find_by_id(params[:id])
  end

  def create
    @note = @branch.notes.new(note_params)
    
    respond_to do |format|
      if @note.save
        format.html { redirect_to branch_notes_path(@branch), notice: 'Note was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @note = Note.find_by_id(params[:id])
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to branch_notes_path(@branch), notice: 'Note was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @note = Note.find_by_id(params[:id])
    @note.destroy
    respond_to do |format|
      format.html { redirect_to branch_notes_path(@branch), notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_branch
      @branch = Branch.find_by_id(params[:branch_id])
    end

    def note_params
      params.require(:note).permit(:branch_id, :comment, :completed_notes, :site_id)
    end
end
