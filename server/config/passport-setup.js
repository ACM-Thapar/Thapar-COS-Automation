const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20');

// *Models
const User = require('../models/user');
const Shopkeeper = require('../models/shopkeeper');

passport.serializeUser((user, done) => {
  done(null, user.id);
});

passport.deserializeUser(async (id, done) => {
  const user = await User.findById(id);
  const shopkeeper = await Shopkeeper.findById(id);
  if (user) {
    done(null, user);
  } else if (shopkeeper) {
    done(null, shopkeeper);
  }
});

// Google Strategy for Users
passport.use(
  'google',
  new GoogleStrategy(
    {
      // options for the google strategy
      callbackURL: '/api/user/google/redirect',
      clientID: process.env.OAUTH_CLIENT_ID,
      clientSecret: process.env.OAUTH_CLIENT_PASSWORD,
    },
    async (accessToken, refreshToken, profile, done) => {
      // check if user already exists
      const user = await User.findOne({ email: profile._json.email });
      if (user) {
        console.log('user exists as \n' + user);
        done(null, user);
      } else {
        console.log(profile);
        let newUser = new User({
          email: profile._json.email,
          name: profile.displayName,
          password: profile.id,
          isGoogleUser: true,
        });
        newUser = await newUser.save();
        console.log('new user created \n' + newUser);
        done(null, newUser);
      }
    },
  ),
);

// Google Strategy for Shopkeepers
passport.use(
  'google-shopkeeper',
  new GoogleStrategy(
    {
      // options for the google strategy
      callbackURL: '/api/auth/google/redirect',
      clientID: process.env.OAUTH_CLIENT_ID,
      clientSecret: process.env.OAUTH_CLIENT_PASSWORD,
    },
    async (accessToken, refreshToken, profile, done) => {
      // check if user already exists
      const user = await Shopkeeper.findOne({ email: profile._json.email });
      if (user) {
        console.log('user exists as \n' + user);
        done(null, user);
      } else {
        console.log(profile);
        let newUser = new Shopkeeper({
          email: profile._json.email,
          name: profile.displayName,
          password: profile.id,
          isGoogleUser: true,
        });
        newUser = await newUser.save();
        console.log('new user created \n' + newUser);
        done(null, newUser);
      }
    },
  ),
);
