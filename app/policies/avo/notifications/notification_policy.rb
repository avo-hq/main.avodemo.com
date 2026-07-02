# Authorizes the AvoNotification resource (avo-notifications). Its model class is
# Avo::Notifications::Notification, so Pundit resolves the policy here. The app runs
# `config.explicit_authorization = true` over a default-denying ApplicationPolicy, so
# without this the bell dropdown and notification resource would be forbidden.
class Avo::Notifications::NotificationPolicy < BaseAvoPolicy
end
