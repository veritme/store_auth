module Spree
  class UserMailer < BaseMailer
    def reset_password_instructions(user, token, *_args)
      current_store_id = _args.inject(:merge)[:current_store_id]
      @current_store = Spree::Store.find(current_store_id) || Spree::Store.current
      @locale = @current_store.has_attribute?(:default_locale) ? @current_store.default_locale : I18n.default_locale
      I18n.locale = @locale if @locale.present?
      @edit_password_reset_url = spree.edit_spree_user_password_url(reset_password_token: token, host: @current_store.url)

      mail(to: user.email, from: from_address, subject: @current_store.name + ' ' + I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions])) do |format|
        format.html {render layout: 'base_mailer'}
      end
    end

    def confirmation_instructions(user, token, _opts = {})
      @confirmation_url = spree.spree_user_confirmation_url(confirmation_token: token, host: Spree::Store.current.url)
      @email = user.email

      mail to: user.email, from: from_address, subject: Spree::Store.current.name + ' ' + I18n.t(:subject, scope: [:devise, :mailer, :confirmation_instructions])
    end
  end
end
