module Ace
  class MainController < Volt::ModelController
    attr_accessor :section, :editor

    # When the dom is ready, setup the editor
    def index_ready
      @updating_attribute = false
      node = section.container_node

      %x{
        var editorDiv = $(node).find('.ace-editor').get(0);
        this.editor = ace.edit(editorDiv);
        this.editor.setTheme("ace/theme/monokai");
        this.editor.renderer.setShowGutter(false);
        this.editor.renderer.setDisplayIndentGuides(false);
        this.editor.getSession().setUseSoftTabs(false);
        this.editor.getSession().setTabSize(0);
        this.editor.renderer.setPadding(5) ;
        this.editor.$blockScrolling = Infinity
        this.editor.setOptions({
            displayIndentGuides: false,
            showGutter: false,
            // showTokenInfo: false,
            fontFamily: '"Anonymous Pro", Monaco, "Lucida Console", "Courier New", Courier, monospace',
            fontSize: 14,
            highlightActiveLine: false,
            showPrintMargin: false
          })

        var mode = 'mustache';
        this.editor.getSession().setUseWrapMode(true);
        this.editor.getSession().setMode("ace/mode/" + mode);
      }
      `console.log(this)`
      # @value_listener = @attrs.code.on('changed') do
      #   `console.log('value changed')`
      #   unless @updating
      #     new_value = @value.cur
      #     `this.editor.setValue(new_value)`
      #   end
      # end
      %x{
        #{@editor}=this.editor;
        var editor = this.editor;
        this.editor.getSession().on('change', function(e) {
          if(!self.updating) {
            #{@updating_attribute = true}

            //new_value = "" + new_value
            #{new_value = nil ; puts 'updating code'}
            new_value = editor.getValue();
            //self.attrs.code  = new_value;
            #{ attrs.code = new_value }
            setImmediate(function(){ #{ @updating_attribute = false } });
          }
        });
      }

      @computation = -> { update_text(attrs.code) }.watch!

      # if @mode
      #   @mode_listener = @mode.on('changed') do
      #     change_mode
      #   end
      # end
      #
      # change_mode
    end

    def before_index_remove
      # @value_listener.remove if @value_listener
      # @mode_listener.remove if @mode_listener
      @computation.stop
    end

    # Change the ace editor mode.  Handle if mode isn't passed in.
    # def change_mode
    #   if @mode
    #     new_mode = @mode.cur.or('ace/mode/mustache')
    #   else
    #     new_mode = 'ace/mode/mustache'
    #   end
    #   `this.editor.getSession().setMode(new_mode)`
    # end

    def update_text(new_text)
      unless @updating_attribute
        @updating = true
        puts 'loading code'
        `#{@editor}.getSession().setValue(#{new_text || ''})`
        @updating = false
      end
    end

  end
end
