import React from 'react';

const Home = () => {
  return (
    <div>
      <h1>Thapar Cos Automation!</h1>
      <a href="http://localhost:5000/api/auth/google">
        Login with google for Shopkeeper
      </a>
      <br />
      <a href="http://localhost:5000/api/user/google">
        Login with google for User
      </a>
    </div>
  );
};

export default Home;
