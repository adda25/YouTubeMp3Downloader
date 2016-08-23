echo Enter your Chrome download path: 
read cdp

echo Enter where you want to save songs: 
read sp

cat <<EOF > conf.txt
$cdp
$sp
EOF