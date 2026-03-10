function suggestUsername() {
    let first = document.getElementById("firstName").value;
    let last = document.getElementById("lastName").value;

    if (first && last) {
        let uid =
            last.substring(0, 4).toLowerCase() +
            first.substring(0, 4).toLowerCase();

        document.getElementById("username").value = uid;
    }
}