module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # avo-ai's Avo::Ai::ChatChannel re-checks chat ownership at subscribe time and calls
    # `current_user`; without this the subscribe raises NameError and the chat panel never
    # streams (the answer only appears on reload).
    identified_by :current_user

    def connect
      # Deliberately no reject_unauthorized_connection: other Turbo streams in this app
      # subscribe without a user, and ChatChannel already fails closed on a nil current_user.
      self.current_user = env["warden"]&.user
    end
  end
end
