class Ocr

  #@@baseUrl = "http://cracow-ocr-app:#{CGI.escape("L4JE7wDmHk3oCH/BNCGI2jIa")}@cloud.ocrsdk.com"
  #@@password = "L4JE7wDmHk3oCH/BNCGI2jIa"
  #@@appname = "cracow-ocr-app"
  #
  # Because Big Marian has no access to above app
  #

  @@baseUrl = "http://#{CGI.escape("Seeker of words in documents")}:#{CGI.escape("IGP0S5KYsUi7WpYCiTa8refF")}@cloud.ocrsdk.com"
  @@password = "IGP0S5KYsUi7WpYCiTa8refF"
  @@appname = "Seeker of words in documents"

  @@ercXml = "public/assets/patterns/erc.xml"

  def self.baseUrl
    @@baseUrl
  end

  def self.appName
    @@appName
  end

  def self.ercXml
    @@ercXml
  end

  #
  # Main method
  #
  def self.processDocument(doc_type, language, images)

    baseUrl = Ocr.baseUrl
    ercXml = Ocr.ercXml

    task_status = nil
    task_id = nil

    #
    # Prepare xml for current DOC
    #
    xmlPattern = XmlBuilder.prepareXmlPattern(doc_type, images)
    #


    #
    # Open prepared file
    #
    xmlFile = File.open("public/assets/patterns/erc.xml", "rb")

    #
    # Image Upload => new task establishing
    #
    iterator = images.count
    firstImageFlag = true
    while(iterator != 0)
      images.each do |i|
        begin
          if(firstImageFlag == true)
            firstImageFlag = false
            response = RestClient.post("#{baseUrl}/submitImage", :upload => {
              :file => File.new(i.image.current_path, 'rb')
              })
          else
            response = RestClient.post("#{baseUrl}/submitImage?taskId=#{task_id}", :upload => {
              :file => File.new(i.image.current_path, 'rb')
              })
          end
        rescue RestClient::ExceptionWithResponse => e
          # Show getTaskStatus errors
          output_response_error(e.response)
          raise
        else
          # Get the task status from response xml
          xml_data = REXML::Document.new(response)
          task_element = xml_data.elements["response/task"]
          task_id = task_element.attributes["id"]
          puts "--- Task id: ---"
          puts task_id
          task_status = task_element.attributes["status"]
          puts "--- Task status: ---"
          puts task_status
        end
        iterator = iterator - 1
      end
    end

    #
    # Image upload is finished
    #
    # Now main method starts => fieldRecognition
    #
    # Here ofcourse shoud be added creation of XML Pattern file and CASE loop for all types of documents
    #
    #if(task_status == "InProgress" or task_status == "Queued" or task_status == "Submitted")
    if(task_status == "Submitted")
      begin
        #response = RestClient.post("#{baseUrl}/processFields?taskId=#{task_id}", :upload => {
        #  :file => File.new(ercXml, 'rb')
        #  })
        response = RestClient.post("#{baseUrl}/processFields?taskId=#{task_id}", :upload => {
          :file => xmlFile
          })
      rescue RestClient::ExceptionWithResponse => e
        # Show processImage errors
        output_response_error(e.response)
        raise
      else
        # Get task id from response xml to check task status later
        xml_data = REXML::Document.new(response)
        task_element = xml_data.elements["response/task"]
        task_id = task_element.attributes["id"]
        task_status = task_element.attributes["status"]
        puts "--- Task status: ---"
        puts task_status
      end
    end

    while task_status == "InProgress" or task_status == "Queued" do
      begin
        sleep(5)

        # Call the getTaskStatus function (see http://ocrsdk.com/documentation/apireference/getTaskStatus)
        response = RestClient.get("#{baseUrl}/getTaskStatus?taskid=#{task_id}")
      rescue RestClient::ExceptionWithResponse => e
        # Show getTaskStatus errors
        output_response_error(e.response)
        raise
      else
        # Get the task status from response xml
        xml_data = REXML::Document.new(response)
        task_element = xml_data.elements["response/task"]
        task_status = task_element.attributes["status"]
        puts "--- Task status: ---"
        puts task_status
      end
    end

    # Check if there were errors ..
    raise "The task hasn't been processed because an error occurred" if task_status == "ProcessingFailed"

    # .. or you don't have enough credits (see http://ocrsdk.com/documentation/specifications/task-statuses for other statuses)
    raise "You don't have enough money on your account to process the task" if task_status == "NotEnoughCredits"

    # Get the result download link
    download_url = xml_data.elements["response/task"].attributes["resultUrl"]

    # Download the result
    recognized_xml = RestClient.get(download_url)
    puts '--- Recognized text ---'
    puts recognized_xml
    return recognized_xml


  end

  # Routine for OCR SDK error output
  def self.output_response_error(response)
    # Parse response xml (see http://ocrsdk.com/documentation/specifications/status-codes)
    xml_data = REXML::Document.new(response)
    error_message = xml_data.elements["error/message"]
    puts "Error: #{error_message.text}" if error_message
  end

end
