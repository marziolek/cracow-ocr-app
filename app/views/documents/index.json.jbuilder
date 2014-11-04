json.array!(@documents) do |document|
  json.extract! document, :id, :language, :doc_type, :image
  json.url document_url(document, format: :json)
end
