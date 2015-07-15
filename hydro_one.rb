        require 'rubygems'
        require 'mechanize'


        login_url = 'https://www.myaccount.hydroone.com/unsecure/EC/ecustomer/en/user/ECCustomerSignInPage.html'
        mech = Mechanize.new
        mech.get(login_url)
        form = mech.page.form_with(:action => /ECInitialization/)
        form['userid'] = 'user'
        form['password'] = 'password'
        form.submit(form.button_with(:value=>'Sign In'))