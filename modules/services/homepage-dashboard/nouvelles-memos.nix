{
  "NOUVELLES par memos" = [
    {
      "Le < Twitter > des GV" = {
        href = "https://memos.gv.je/explore";
        notdescription = "Permet le fait de noter des memos privés, protégés (pour tous les utilisateurs identifiés) et publics";
        noticon = "sh-memos";
        icon = "mdi-bird";
        widget = {
          type = "customapi";
          url = "https://miniflux.gv.je/v1/feeds/2/entries?limit=5&order=published_at&direction=desc&status=unread";
          display = "dynamic-list";
          headers = {
            X-AUTH-TOKEN = "3421d3702a8784ea19d7d94f5ef40f6e86b4af02cb6a8362f5492a4ad7203efb";
          };
          mappings = {
            items = "entries";
            name = "title";
            label = "published_at";
            limit = "6";
            format = "date";
            target = "{url}";
          };
        };
      };
    }
  ];
}
