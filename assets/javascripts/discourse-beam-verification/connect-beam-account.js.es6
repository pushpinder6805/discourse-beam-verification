import { withPluginApi } from 'discourse/lib/plugin-api';

function initialize(api) {
  api.modifyClass('controller:preferences/account', {
    actions: {
      connectBeamAccount() {
        let beamAddress = this.get('beamAddress');
        let user = this.get('model');

        user.set('custom_fields.beam_address', beamAddress);
        user.save().then(() => {
          alert('BEAM account connected!');
        });
      }
    }
  });

  api.modifyClass('component:preferences-account', {
    didInsertElement() {
      this._super(...arguments);
      this.$('.custom-user-field').append(
        '<div><label>BEAM Address</label><input id="beamAddress" /></div>'
      );
      this.$('.custom-user-field').append(
        '<button onclick="Discourse.__container__.lookup(\'controller:preferences/account\').send(\'connectBeamAccount\')">Connect BEAM Account</button>'
      );
    }
  });
}

export default {
  name: 'connect-beam-account',
  initialize
};
