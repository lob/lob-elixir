# How to Contribute

We welcome contributions from the community and are pleased to have them. Please follow this guide when logging issues or making code changes.

Make sure you have Elixir 1.4 or greater installed. Copy and paste the following commands in your projects directory.

    git clone https://github.com/lob/lob-elixir.git
    cd lob-elixir
    mix deps.get

## Contributing Instructions

1. Fork repo.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Make sure the tests pass (`mix coveralls.html`).
6. Open up `cover/excoveralls.html` in your browser and add tests if required to meet the minimum coverage threshold.
7. Create new Pull Request.
