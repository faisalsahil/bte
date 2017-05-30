class ClientMailer < ApplicationMailer
  # default from: 'info@appsgenii.com'
  def send_email(branch_id, template_id)
    @template     = Template.find_by_id(template_id)
    @branch       = Branch.find_by_id(branch_id)
    @html_content = content_setting(@template.html, @branch)
    subject       = content_setting(@template.subject, @branch)
    mail(:to => @branch.contact_email, :cc=> @template.cc, :subject => subject, :from => @template.from_email)
  end
  
  def send_email_from_history(branch_id, history_id)
    @email_history = EmailHistory.find_by_id(history_id)
    @branch        = Branch.find_by_id(branch_id)
    @html_content  = content_setting(@email_history.html,    @branch)
    subject        = content_setting(@email_history.subject, @branch)
    mail(:to => @branch.contact_email, :cc=> @email_history.cc, :subject => subject, :from => @email_history.from_email)
  end
  
  def content_setting(content, branch)
    if branch.contact_email.present?
      content = content.gsub("{{EMAIL}}", branch.contact_email)
    else
      content = content.gsub("{{EMAIL}}", 'EMAIL')
    end
    
    if branch.branch_name.present?
      content = content.gsub("{{NAME}}", branch.branch_name)
    else
      content = content.gsub("{{NAME}}", 'FULL_NAME')
    end
    
    
    if branch.contact_phone.present?
      content = content.gsub("{{PHONE}}",      branch.contact_phone)
    else
      content = content.gsub("{{PHONE}}",      'PHONE')
    end
    
    # if branch.url.present?
    #   content = content.gsub("{{URL}}",        branch.url)
    # else
    #   content = content.gsub("{{URL}}",        '\/')
    # end
    
    content
  end
end
