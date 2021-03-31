# frozen_string_literal: true

module ActiveStorageHelpers
  def create_file_blob(filename: 'test.jpg', content_type: 'image/jpeg', metadata: nil)
    ActiveStorage::Blob.create_after_upload! io: File.open(Rails.root.join('spec', 'files', filename)),
                                             filename: filename,
                                             content_type: content_type,
                                             metadata: metadata
  end
end
