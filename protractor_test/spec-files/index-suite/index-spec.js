/*
Whalefeed test
Index Component
@author rguimera
*/
describe('Whalefeed - IndexComponent', function() {
  var signUpLink = element(by.linkText('Sign up!'));
  var signInLink = element(by.linkText('Sign in!'));
  var aboutUsLink = element(by.linkText('About us'));
  var signUpTitleText = element(by.xpath('//*[@id="greeny-main-page-section"]/h2'));
  var signInTitleText = element(by.xpath('//*[@id="greeny-main-page-section"]/h2'));
  var aboutUsTitleText = element(by.xpath('//*[@id="greeny-main-page-section"]/h2[1]'));

  beforeEach(function() {
    browser.get('');
  });

  it('Page title', function() {
    expect(browser.getTitle()).toEqual('Whalefeed');
  });

  it('See Sign Up Link', function() {
  	expect(signUpLink.getText()).toEqual('Sign up!');
  });

  it('Can go to Sign Up Component', function() {
    signUpLink.click();
    expect(signUpTitleText.getText()).toEqual('Sign up!');
  });

  it('See Sign In Link', function() {
    expect(signInLink.getText()).toEqual('Sign in!');
  });

  it('Can go to Sign In Component', function() {
    signInLink.click();
    expect(signInTitleText.getText()).toEqual('Sign in!');
  });

  it('See About Us Link', function() {
    expect(aboutUsLink.getText()).toEqual('About us');
  });

  it('Can go to About Us Component', function() {
    aboutUsLink.click();
    expect(aboutUsTitleText.getText()).toEqual('About us');
  });

});
