
describe("clicking a show link", function() {

  it("grabs the first line of text", function() {
    loadFixtures("firstline.html");
    init();
    var description = $('.description').text(); // Need text
    var firstline = getFirstLine(description);
    expect(firstline).toEqual('This is the first line.');
  });

});
