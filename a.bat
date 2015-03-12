git pull  https://github.com/libia0/doomed.git
ssh-keygen -t rsa -C "db0@qq.com"  
ssh -T git@github.com
git remote add origin git@github.com:libia0/doomed.git  
git commit -m "1.0"
git checkout
git config --global user.email "db0@qq.com"
git config --global user.name "db00"
git add .
git push .
exit
git push origin db00
zip project_%date:~0,10%.zip -r src bat cert icons *.bat *.xml *.as3proj
zip project_`date +%Y%m%d`.zip -r src bat cert icons *.bat *.xml *.as3proj
adt -package -target ipa-test-interpreter   -storetype pkcs12 -keystore "cert/iphone_dev.p12" -storepass 1234 -provisioning-profile cert/JNY.mobileprovision "dist\smain-test-interpreter.ipa" "application.xml" -C bin . -C "icons/ios" . 
