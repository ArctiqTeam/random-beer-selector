define(["lib/es6-promise", "lib/jquery"], function (Es6Promise, $) {
  return function (args) {
    var args = args || {};
    var limit = args.limit || Infinity;
    var query = args.query || {};

    var iterations = 0;

    var per_page_min = 5;
    var per_page_max = 10;
    var per_page = (limit <= per_page_min) ?
      per_page_min :
        (limit < per_page_max) ?
          limit :
          per_page_max;
    var current_page = 1;
    var is_final_page = false;

    var inventories = [];

    var done = function () {
      return (
        iterations > limit ||
       (inventories.length === 0 && is_final_page)
     );
    };

    return {
      next: function () {
        return new Promise(function (resolve, reject) {
          iterations++;

          if (done()) {
            resolve({done: true});
          } else if (inventories.length === 0) {
            $.ajax({
              url: "http://lcboapi.com/inventories",
              dataType: "jsonp",
              data: $.extend({}, query, {page: current_page, per_page: per_page})
            })
            .then(function (response) {
              current_page = response.pager.next_page;
              is_final_page = response.pager.is_final_page;

              if (!Array.isArray(response.result)) {
                reject(response.message);
              } else {
                inventories = response.result;
                resolve({
                  done: false,
                  value: inventories.pop()
                });
              }
            })
            .fail(reject);
          } else {
            resolve({
              done: false,
              value: inventories.pop()
            })
          }
        });
      }
    };
  };
});
