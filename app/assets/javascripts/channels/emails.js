App.emails = App.cable.subscriptions.create("EmailsChannel", {
    received: function(data) {
        // Update the emails list
        const emailsTable = document.getElementById('emails-table');
        if (emailsTable) {
            const newRow = emailsTable.insertRow(1); // Insert below the header row
            newRow.innerHTML = '<td>' + data.from + '</td>' +
                '<td><a href="/emails/' + data.email_id + '">' + data.subject + '</a></td>' +
                '<td>' + data.date + '</td>';
        }
    }
});
