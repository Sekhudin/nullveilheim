{ ... }:

{
  nixvimDashboard = {
    theme = "hyper";
    banner = rec {
      header = {
        ascii = "absolute_cinema";
        head = 16;
        gap = 1;
      };
      footer = {
        ascii = header.ascii;
        tail = 8;
        gap = 1;
      };
    };
  };
}
