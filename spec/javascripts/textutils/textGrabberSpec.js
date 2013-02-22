
describe("clicking a show link", function() {

  it("grabs the first line of text", function() {
    loadFixtures("firstline.html");
    init();
    var description = $('.task-description').text(); // Need text
    console.log(description);
    var firstline = getFirstLine(description);
    console.log(firstline);
    expect(firstline).toEqual('This is the first line first div');
  });

});
