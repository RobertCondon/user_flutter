class EmailFetcherJob
  require 'net/imap'
  include SuckerPunch::Job

  def perform
    imap = Net::IMAP.new('localhost', port: 993, ssl: true)
    imap.login('rob', 'buster')
    imap.select('INBOX')

    loop do
      imap.idle do |response|
        if response.kind_of?(Net::IMAP::UntaggedResponse) && response.name == "EXISTS"
          # New email arrived
          process_new_emails(imap)
        end
      end
    end

  rescue => e
    Rails.logger.error "EmailFetcherJob Error: #{e.message}"
    sleep 5
    retry
  end

  def process_new_emails(imap)
    imap.uid_search(['UNSEEN']).each do |uid|
      msg = imap.uid_fetch(uid, 'RFC822')[0].attr['RFC822']
      mail = Mail.read_from_string(msg)

      Email.create(
        message_id: mail.message_id,
        from: mail.from.join(', '),
        to: mail.to.join(', '),
        subject: mail.subject,
        body: mail.decoded,
        date: mail.date
      )

      # Mark email as seen
      imap.uid_store(uid, '+FLAGS', [:Seen])

      ActionCable.server.broadcast 'emails', email_id: email.id, subject: email.subject, from: email.from, date: email.date.strftime('%Y-%m-%d %H:%M')
    end
  end
end
