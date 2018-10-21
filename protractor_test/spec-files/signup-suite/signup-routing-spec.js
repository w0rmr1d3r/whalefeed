/*
Whalefeed test
SignUp Component
@author rguimera
*/
describe('Whalefeed - SignUpComponent Routing', function() {
  var signUpLink = element(by.linkText('Sign up!'));
  var backToMainLink = element(by.linkText('Back to the main page'));
  var signUpTitle = element(by.xpath('//*[@id="greeny-main-page-section"]/h2'));
  var indexText = element(by.xpath('//*[@id="greeny-main-page-section"]/p'));
  var signInLink = element(by.linkText('Sign in!'));
  var signInTitle = element(by.xpath('//*[@id="greeny-main-page-section"]/h2'));

  beforeEach(function() {
    browser.get('');
    signUpLink.click();
  });

  it('Page title', function() {
    expect(browser.getTitle()).toEqual('Whalefeed');
  });

  it('See Sign up title', function() {
  	expect(signUpTitle.getText()).toEqual('Sign up!');
  });

  it('See go back to main page link', function() {
    expect(backToMainLink.getText()).toEqual('Back to the main page');
  });

  it('Can go back to index', function() {
    backToMainLink.click();
    expect(indexText.getText()).toEqual('The only NGO cooperative social network. And yes, our color is blue.');
  });

  it('See Sign in link', function() {
    expect(signInLink.getText()).toEqual('Sign in!');
  });

  it('Can go to sign in Component', function() {
    signInLink.click();
    expect(signInTitle.getText()).toEqual('Sign in!');
  });
});
