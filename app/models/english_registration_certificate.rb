class EnglishRegistrationCertificate < ActiveRecord::Base

	belongs_to :document, dependent: :destroy
	validates :document, presence: true
	

	def ocrProcess(appId = "cracow-ocr-app", pass = CGI.escape("L4JE7wDmHk3oCH/BNCGI2jIa"), fileName = "./images/image.jpg",lang = "English")
		# IMPORTANT!
		# To create an application and obtain a password,
		# register at http://cloud.ocrsdk.com/Account/Register
		# More info on getting your application id and password at
		# http://ocrsdk.com/documentation/faq/#faq3

		# CGI.escape is needed to escape whitespaces, slashes and other symbols
		# that could invalidate the URI if any
		# Name of application you created

		# IMPORTANT!
		baseUrl = "http://#{appId}:#{pass}@cloud.ocrsdk.com"

		# Upload and process the image (see http://ocrsdk.com/documentation/apireference/processImage)
		begin
			response = RestClient.post("#{baseUrl}/processImage?language=#{lang}&profile=textExtraction&exportFormat=txt", :upload => {
				:file => File.new(fileName, 'rb')
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
			puts "--- Task id: ---"
			puts task_id
		  # Obtain the task status here so that the loop below is not started
		  # if your application account has not enough credits
		  task_status = task_element.attributes["status"]
			puts "--- Task status: ---"
			puts task_status
		end

		# Get task information in a loop until task processing finishes
		while task_status == "InProgress" or task_status == "Queued" do
			begin
			    # Note: it's recommended that your application waits
			    # at least 2 seconds before making the first getTaskStatus request
			    # and also between such requests for the same task.
			    # Making requests more often will not improve your application performance.
			    # Note: if your application queues several files and waits for them
			    # it's recommended that you use listFinishedTasks instead (which is described
			    # at http://ocrsdk.com/documentation/apireference/listFinishedTasks/).
			    # Wait a bit
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
		recognized_text = RestClient.get(download_url)
		puts '--- Recognized text ---'
		puts recognized_text
		return recognized_text
	end

	# Routine for OCR SDK error output
	def output_response_error(response)
		# Parse response xml (see http://ocrsdk.com/documentation/specifications/status-codes)
		xml_data = REXML::Document.new(response)
		error_message = xml_data.elements["error/message"]
		puts "Error: #{error_message.text}" if error_message
	end
end