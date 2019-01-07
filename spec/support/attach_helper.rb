module AttachHelpers
  def attach_to(owner)
    attachments = owner.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"),
                               filename: "spec_helper.rb", content_type: "text/plain")
    attachments.first
  end
end

