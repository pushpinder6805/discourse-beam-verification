# name: discourse-beam-verification
# about: Verifies BEAM token accounts for Discourse users
# version: 0.1
# authors: Your Name
# url: https://github.com/your-repo/discourse-beam-verification

enabled_site_setting :beam_verification_enabled

after_initialize do
  # Plugin code goes here
  require_dependency 'jobs/regular/verify_beam_account'
  load File.expand_path('../lib/beam_verification.rb', __FILE__)
end

after_initialize do
    module ::BeamVerification
      class Engine < ::Rails::Engine
        engine_name "beam_verification"
        isolate_namespace BeamVerification
      end
    end
  
    DiscourseEvent.on(:user_logged_in) do |user|
      Jobs.enqueue(:verify_beam_account, user_id: user.id)
    end
  
    module ::Jobs
      class VerifyBeamAccount < ::Jobs::Base
        def execute(args)
          user = User.find(args[:user_id])
          beam_address = user.custom_fields['beam_address']
  
          if beam_address.present?
            balance = BeamVerification.get_balance(beam_address)
  
            if balance >= 1
              group = Group.find_by(name: "beam_verified")
            else
              group = Group.find_by(name: "non_verified_beam")
            end
  
            group.add(user)
          end
        end
      end
    end
  end
  