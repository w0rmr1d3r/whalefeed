/*
Whalefeed test
SignIn Component
@author rguimera
*/
describe('Whalefeed - SignInComponent Routing', function() {
  var signInLink = element(by.linkText('Sign in!'));
  var signInTitle = element(by.xpath('//*[@id="greeny-main-page-section"]/h2'));
  var backToMainLink = element(by.linkText('Back to the main page'));
  var signUpLink = element(by.linkText('Sign up!'));
  var indexText = element(by.xpath('//*[@id="greeny-main-page-section"]/p'));
  var signUpTitle = element(by.xpath('//*[@id="greeny-main-page-section"]/h2'));

  beforeEach(function() {
    browser.get('');
    signInLink.click();
  });

  it('Page title', function() {
    expect(browser.getTitle()).toEqual('Whalefeed');
  });

  it('See Sign in title', function() {
  	expect(signInTitle.getText()).toEqual('Sign in!');
  });

  it('See go back to main page link', function() {
    expect(backToMainLink.getText()).toEqual('Back to the main page');
  });

  it('Can go back to index', function() {
    backToMainLink.click();
    expect(indexText.getText()).toEqual('The only NGO cooperative social network. And yes, our color is blue.');
  });

  it('See Sign up link', function() {
    expect(signUpLink.getText()).toEqual('Sign up!');
  });

  it('Can go to sign up Component', function() {
    signUpLink.click();
    expect(signUpTitle.getText()).toEqual('Sign up!');
  });
});
