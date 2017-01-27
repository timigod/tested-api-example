class Notifier < ApplicationMailer
  default from: "notifier@crossover-support.com"

  def support_assignment(support, ticket)
    @support = support
    @ticket = ticket
    @user = ticket.user
    mail(to: @support.email, subject: "Alert!!! Somebody Needs Support")
  end
end
