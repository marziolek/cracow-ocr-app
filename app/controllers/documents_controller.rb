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
    #@document = Document.find(params[:id])
    #
    # Above line is unnecesary because there is this magic before_action :set_document ... hell yeah
    #
    @documentImages = @document.document_images.load
    case @document.doc_type
    when 'registration_certificate'
      case @document.language
      when 'English'
        #@translation = @document.english_registration_certificate
        #appid = CGI.escape("Seeker of words in documents")
        #passss = CGI.escape("IGP0S5KYsUi7WpYCiTa8refF")
        #
        # Here comes the EACH loop over all the images stored in @documentImages objects - probablu mulpile request :: submitImage
        #
        #filename = @document.image.current_path
        #language = "English"
        #url = "http://#{appid}:#{passss}@cloud.ocrsdk.com"
        @document.translation
      end
    else
      @translation = EnglishRegistrationCertificate.new()
    end
  end

  # GET /documents/new
  def new
    @document = Document.new
    @documentImages = @document.document_images.build
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
      when "English"
        @translation = EnglishRegistrationCertificate.new()
        @translation.document = @document

        #here comes preProcessing and OCR things
      end
    else
      #here should be redirection to document#new
    end

    respond_to do |format|
      if @document.save
        params[:document_images]['image'].each do |i|
          @document_image = @document.document_images.create!(:image => i)
          @imageUrl = @document_image.image.current_path
          @imageDimensions = FastImage.size(@imageUrl) #=> [x,y]

          #working stuff
          translation = Ocr.processDocument(@document.doc_type, @document.language, @document.document_images.load)
          @xmlTranslation = Nokogiri::XML(translation)

          #
          # Here comes the XML parser
          #

          @document.translation = @xmlTranslation.css("value").text

          #
          # @document variables should be set before savin' !!
          #

          @document.save
        end

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

  def save_translation(img_path)

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
