        require 'rubygems'
        require 'mechanize'


        login_url = 'http://myenercare.ca/users/login'
        mech = Mechanize.new
        mech.get(login_url)
        form = mech.page.form_with(:action => /login/)
        form['Username'] = 'user'
        form['Password'] = 'password'
        form.submit(form.button_with(:value=>'Log In'))