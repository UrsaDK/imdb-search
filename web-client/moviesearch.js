class MovieSearch {
  constructor(injected_config) {
    this._config = injected_config || new Map()
      .set('html.form', 'search_form')
      .set('html.query', 'q')
      .set('html.column', 'c')
      .set('html.results', 'results')
      .set('query.minsize', 3)
      .set('query.idle_ms', 750)
      .set('api.endpoint', 'http://localhost:9292/v1');
      this.initEventListeners();
  }

  get config() {
    return this._config;
  }

  get timer() {
    return this._timer;
  }

  set timer(value) {
    this._timer = value;
  }

  get form() {
    return document.getElementById(this.config.get('html.form'));
  }

  get query() {
    return document.getElementById(this.config.get('html.query'));
  }

  get column() {
    return document.getElementById(this.config.get('html.column'));
  }

  get results() {
    return document.getElementById(this.config.get('html.results'));
  }

  initEventListeners() {
    this.query.addEventListener('input', e => this.onInput(e));
    this.form.addEventListener('submit', e => {
      e.preventDefault();
      new MovieSearch.Request(this);
      return false;
    });
  }

  onInput(event) {
    if (!this.timer) {
      const ui = new MovieSearch.UI(this);
      this.results.replaceWith(ui.createResultsTable('', 'loader'));
    } else {
      clearTimeout(this.timer);
    }
    this.timer = setTimeout(
      () => { this.timer = undefined; new MovieSearch.Request(this) },
      this.config.get('query.idle_ms')
    );
  }

  onInvalidQuery() {
    const ui = new MovieSearch.UI(this);
    const message = `Minimum search string length: ${this.config.get('query.minsize')} characters`;
    this.results.replaceWith(ui.createResultsTable(message, 'info'));
  }

  onHttpResponse(data) {
    const ui = new MovieSearch.UI(this);
    if (data.length > 0) {
      this.results.replaceWith(ui.createResultsTable(data));
    } else {
      const message = 'No results found.';
      this.results.replaceWith(ui.createResultsTable(message, 'warning'));
    }
  }

  onHttpError(error) {
    const ui = new MovieSearch.UI(this);
    const message = 'Error fetching data from the API. See the console for more info.';
    this.results.replaceWith(ui.createResultsTable(message, 'danger'));
    console.log(error);
  }

  static get Request() {
    return class Request {
      constructor(search) {
        this._search = search;
        this.validateQuery();
      }

      get search() {
        return this._search;
      }

      validateQuery() {
        const query_length = this.search.query.value.length;
        const min_query_length = this.search.config.get('query.minsize');
        if (query_length >= min_query_length) { this.sendHttpRequest(); }
        else { this.search.onInvalidQuery(); }
      }

      sendHttpRequest() {
        const config = {
          method: 'get',
        }
        fetch(this.requestUrl(), config)
          .then(response => response.json())
          .then(data => this.search.onHttpResponse(data))
          .catch(error => this.search.onHttpError(error));
      }

      requestUrl() {
        const endpoint = this.search.config.get('api.endpoint');
        const column = this.search.column.value;
        const query = this.search.query.value;
        return `${endpoint}/${column}/${query}`
      }
    }
  }

  static get UI() {
    return class UI {
      constructor(search) {
        this._search = search;
        this.results = search.results.cloneNode(true);
      }

      get search() {
        return this._search;
      }

      get results() {
        return this._results.cloneNode(true);
      }

      set results(table) {
        const children = table.getElementsByTagName('tbody')[0].children;
        Array.from(children).forEach(tr => tr.remove());
        this._results = table;
      }

      createResultsTable(data, klass = '') {
        const table = this.results;
        const tbody = table.getElementsByTagName('tbody')[0];
        if (typeof data === 'object') {
          Array.from(data).forEach(row => {
            tbody.appendChild(this.createResultsRow(row));
          });
        } else {
          tbody.appendChild(this.createMessageRow(data, klass));
        }
        return table;
      }

      createResultsRow(data) {
        const row = document.createElement('tr');
        Object.entries(data).forEach(([column, value]) => {
          const cell = document.createElement('td');
          if (Array.isArray(value)) { value = value.join(', ') }
          const textnode = document.createTextNode(value);
          cell.setAttribute('data-label', column);
          cell.appendChild(textnode);
          row.appendChild(cell);
        });
        return row;
      }

      createMessageRow(text, klass) {
        const row = document.createElement('tr');
        const cell = document.createElement('td');
        const textnode = document.createTextNode(text);
        cell.setAttribute('colspan', this.results.rows[0].cells.length);
        cell.classList.add('no-results', klass);
        cell.appendChild(textnode);
        row.appendChild(cell);
        return row;
      }
    }
  }
}
