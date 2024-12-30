{
  chronic = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hrdkn4g8x7dlzxwb1rfgr8kw3bp4ywg5l4y4i9c2g5cwv62yvvn";
      type = "gem";
    };
    version = "0.10.2";
  };
  sequel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gqqnqrfayhwhkp0vy3frv68sgc7klyd6mfisx1j3djjvlyc7hmr";
      type = "gem";
    };
    version = "5.30.0";
  };
  sqlite3 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "073hd24qwx9j26cqbk0jma0kiajjv9fb8swv9rnz8j4mf0ygcxzs";
      type = "gem";
    };
    version = "1.7.3";
  };
  timetrap = {
    dependencies = ["chronic" "sequel" "sqlite3"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pfg5c3kmh1jfaaszw253bi93ixa6cznqmsafrcpccrdg9r8j2k8";
      type = "gem";
    };
    version = "1.15.2";
  };
}
