/*
Whalefeed test
About Component
@author rguimera
*/
describe('Whalefeed - AboutComponent', function() {
  var aboutUsLink = element(by.linkText('About us'));
  var aboutUsTitle = element(by.xpath('//*[@id="greeny-main-page-section"]/h2[1]'));
  var indexText = element(by.xpath('//*[@id="greeny-main-page-section"]/p'));
  var backToMainLink = element(by.linkText('Back to the main page'));

  beforeEach(function() {
    browser.get('');
    aboutUsLink.click();
  });

  it('Page title', function() {
    expect(browser.getTitle()).toEqual('Whalefeed');
  });

  it('See About us title', function() {
    
  	expect(aboutUsTitle.getText()).toEqual('About us');
  });

  it('See go back to main page link', function() {
    expect(backToMainLink.getText()).toEqual('Back to the main page');
  });

  it('Can go back to index', function() {
    backToMainLink.click();
    expect(indexText.getText()).toEqual('The only NGO cooperative social network. And yes, our color is blue.');
  });

});
