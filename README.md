# scan_organizer
digital document assistant
🇩🇪 **[For German version, see Bit-Field](https://linux.bit-field.de/scan_organizer.de.html)**

---

## 🔹 What Does Scan Organizer Do?
Scan Organizer is your **digital assistant for document management** – **simple, fast, and automated**.
Whether you're dealing with **invoices, contracts, type plates, or phone photos**, with one click or an email, your documents are **immediately tagged, sorted, and searchable** – **no manual sorting, no complex setup required**.

---

## 🔹 Who Is It For?
✅ **Technicians & Field Service Engineers:**
   - Photograph **type plates or spare part information** on-site → send via email.
   - Documents are **automatically sorted into the correct project folder** (e.g., `Projects/CustomerX/`) with labels like **"Check Price"**.
   - **No need to think about filing** – the tool handles it for you.

✅ **Craftsmen & Service Providers:**
   - Scan **sketches, damage photos, or material lists** on-site → everything is **automatically sorted**.

✅ **Private Users:**
   - **Invoices, warranty documents, or notes** – all in one place, **without manual sorting**.

---

## 🔹 Why Use Scan Organizer?
+ **Simple:** No Docker containers, no complex databases – **runs on any Linux machine**.
+ **Fast:** Ready to use in **about 15 minutes** (using `INSTALL.sh`).
+ **Automatic:** Documents are **immediately tagged and sorted** – you don’t have to worry about it.
+ **Secure:** With the **SaaS version**, your documents are **protected even if the device is lost**.

---

## 📥 Installation
### **Option 1: Automatic Installation (Recommended)**
Download and run the **INSTALL.sh** script. It will automatically fetch the latest `tar.gz` from Bit-Field and set everything up:

    wget https://linux.bit-field.de/downloads/INSTALL.sh
    chmod +x INSTALL.sh
   ./INSTALL.sh


After installation, run a test:

    ./scan_organizer.py file ~/scans/test.jpg --label "Test"

(Replace ~/scans/test.jpg with your document path.)


---

## 📌 Command Examples
   Command | Description |
|---------|-------------|
| `./scan_organizer.py --scan 'escl:http://192.168.178.37:80'` | Scans from the scanner with this IP and saves the document. |
| `./scan_organizer.py --scan brother --source ADF` | Scans from the **Brother scanner** using the **Automatic Document Feeder (ADF)**. |
| `./scan_organizer.py --scan --pdf_dir "Rechnungen/2026"` | Scans and saves the PDF to `~/dokumente/Rechnungen/2026/`. |
| `./scan_organizer.py --file rechnung.jpg --label "Rechnung"` | Processes an existing file (JPG/PNG) and assigns the label **"Rechnung"**. |
| `./scan_organizer.py --file rechnung.jpg --pdf_dir "Verträge"` | Processes a file and saves the PDF to `~/dokumente/Verträge/`. |
| `./scan_organizer.py --search "Muster AG"` | Searches **all documents** for the term `"Muster AG"`. |
| `./scan_organizer.py --help` | Shows the **help page** with all available options. |
