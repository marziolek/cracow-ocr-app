class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = Document.find(params[:id])
    case @document.doc_type
    when 'registration_certificate'
      case @document.language
      when 'english'
        @translation = @document.english_registration_certificate

    appid = CGI.escape("Seeker of words in documents")
    passss = CGI.escape("N2kOz2A8nlqIAwlxHYi8du+K")
    filename = './images/image.jpg'
    language = "English"
    url = "http://#{appid}:#{passss}@cloud.ocrsdk.com"


        @ocrResult = @translation.ocrProcess(appid,passss,filename,language,url)
      end
    else
      @translation = EnglishRegistrationCertificate.new()
    end
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)
    case @document.doc_type
    when 'registration_certificate'
      case @document.language
      when 'english'
        @translation = EnglishRegistrationCertificate.new()
        @translation.document = @document
        @translation.number = 'asd123'
        #here comes preProcessing and OCR things
      end
    else
      #here should be redirection to document#new
    end

    respond_to do |format|
      if @document.save
        if @translation.save
          format.html { redirect_to @document, notice: 'Document was successfully created.' }
          format.json { render action: 'show', status: :created, location: @document }
        else
          @document.destroy
          format.html { render action: 'new' }
          format.json { render json: @document.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:language, :doc_type, :image)
    end
end