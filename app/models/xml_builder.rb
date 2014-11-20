class XmlBuilder

  @@ercXml = "public/assets/patterns/erc.xml"
  @@ercPattern = "public/assets/patterns/ercPattern.xml"
  #
  # Hash of pairs (filed_name = hash of four - containing four variable :: left, top, right, bottom) .
  #
  @@ercFields = {ocr1: {left: 0.4, top: 0.025, right: 0.57, bottom: 0.05}}

  def self.ercPattern
    @@ercPattern
  end

  def self.ercXml
    @@ercXml
  end

  def self.ercFields
    @@ercFields
  end

  def self.prepareXmlPattern(doc_type, images)
    #
    # Get images dimensions as table of hashes [[:x, :y],[:x,:y],...]
    #
    dimensions = []
    images.each do |i|
      imageDimensions = FastImage.size(i.image.current_path) # => [x,y]
      dimensions.push({x: imageDimensions[0], y: imageDimensions[1]})
    end

    #
    # Depending on given doc_type build apropriate XML file
    #
    # UPDATE :: It can use one file instead of two - which option is better??
    #
    case doc_type
    when "registration_certificate"
      fields = XmlBuilder.ercFields
      xmlFile = Nokogiri::XML(open(XmlBuilder.ercPattern))
      xmlFile.css("page").each do |page|
        pageDimensions = dimensions.shift
        page.css("text").each do |t|
          fieldId = t.attributes["id"].value
          t.attributes["left"].value = (fields[fieldId.to_sym][:left] * pageDimensions[:x].to_i).to_i.to_s
          t.attributes["top"].value = (fields[fieldId.to_sym][:top] * pageDimensions[:y].to_i).to_i.to_s
          t.attributes["right"].value = (fields[fieldId.to_sym][:right] * pageDimensions[:x].to_i).to_i.to_s
          t.attributes["bottom"].value = (fields[fieldId.to_sym][:bottom] * pageDimensions[:y].to_i).to_i.to_s
        end
      end
    end
    xml = File.open(XmlBuilder.ercXml, 'w') do |f|
      f.write(xmlFile.to_xml)
    end

  end

end
